# FSD Implementation Patterns

Code patterns for Feature-Sliced Design architecture.

---

## Entity Pattern

### Complete Entity: User

**Model Layer** (`entities/user/model/`):

```typescript
// entities/user/model/types.ts
export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  role: UserRole;
  createdAt: Date;
}

export type UserRole = 'admin' | 'user' | 'guest';

export interface UserDTO {
  id: number;
  email: string;
  name: string;
  avatar_url: string | null;
  role: string;
  created_at: string;
}
```

```typescript
// entities/user/model/mapper.ts
import type { User, UserDTO, UserRole } from './types';

export function mapUserDTO(dto: UserDTO): User {
  return {
    id: String(dto.id),
    email: dto.email,
    name: dto.name,
    avatar: dto.avatar_url ?? undefined,
    role: dto.role as UserRole,
    createdAt: new Date(dto.created_at),
  };
}
```

```typescript
// entities/user/model/schema.ts
import { z } from 'zod';

export const userSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
});

export type UserFormData = z.infer<typeof userSchema>;
```

**API Layer** (`entities/user/api/`):

```typescript
// entities/user/api/userApi.ts
import { apiClient } from '@/shared/api';
import { mapUserDTO } from '../model/mapper';
import type { User, UserDTO } from '../model/types';

export async function getCurrentUser(): Promise<User> {
  const { data } = await apiClient.get<UserDTO>('/users/me');
  return mapUserDTO(data);
}
```

```typescript
// entities/user/api/queries.ts — React Query integration
import { useQuery } from '@tanstack/react-query';
import { getCurrentUser, getUserById } from './userApi';

export const userKeys = {
  all: ['users'] as const,
  current: () => [...userKeys.all, 'current'] as const,
  detail: (id: string) => [...userKeys.all, 'detail', id] as const,
};

export function useCurrentUser() {
  return useQuery({ queryKey: userKeys.current(), queryFn: getCurrentUser });
}

export function useUser(id: string) {
  return useQuery({ queryKey: userKeys.detail(id), queryFn: () => getUserById(id), enabled: !!id });
}
```

**UI Layer** (`entities/user/ui/`):

```tsx
// entities/user/ui/UserAvatar.tsx
import type { User } from '../model/types';

interface UserAvatarProps {
  user: User;
  size?: 'sm' | 'md' | 'lg';
}

export function UserAvatar({ user, size = 'md' }: UserAvatarProps) {
  const sizes = { sm: 'w-8 h-8', md: 'w-10 h-10', lg: 'w-14 h-14' };

  if (user.avatar) {
    return <img src={user.avatar} alt={user.name} className={`rounded-full ${sizes[size]}`} />;
  }
  return (
    <div className={`rounded-full bg-gray-200 flex items-center justify-center ${sizes[size]}`}>
      {user.name.charAt(0).toUpperCase()}
    </div>
  );
}
```

**Public API** (`entities/user/index.ts`):

```typescript
export { UserAvatar } from './ui/UserAvatar';
export { getCurrentUser, getUserById } from './api/userApi';
export { useCurrentUser, useUser, userKeys } from './api/queries';
export type { User, UserRole, UserDTO } from './model/types';
export { mapUserDTO } from './model/mapper';
export { userSchema, type UserFormData } from './model/schema';
```

---

## Feature Pattern

### Complete Feature: Authentication

**Model Layer** (`features/auth/model/`):

```typescript
// features/auth/model/types.ts
export interface LoginCredentials { email: string; password: string; }
export interface AuthTokens { accessToken: string; refreshToken: string; }
```

```typescript
// features/auth/model/store.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '@/entities/user';
import type { AuthTokens } from './types';

interface AuthState {
  user: User | null;
  tokens: AuthTokens | null;
  isAuthenticated: boolean;
  setAuth: (user: User, tokens: AuthTokens) => void;
  clearAuth: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null, tokens: null, isAuthenticated: false,
      setAuth: (user, tokens) => set({ user, tokens, isAuthenticated: true }),
      clearAuth: () => set({ user: null, tokens: null, isAuthenticated: false }),
    }),
    { name: 'auth-storage' }
  )
);
```

**API Layer** (`features/auth/api/`):

```typescript
// features/auth/api/authApi.ts
import { apiClient } from '@/shared/api';
import { mapUserDTO, type User, type UserDTO } from '@/entities/user';
import type { LoginCredentials, AuthTokens } from '../model/types';

export async function login(credentials: LoginCredentials): Promise<{ user: User; tokens: AuthTokens }> {
  const { data } = await apiClient.post<{ user: UserDTO; access_token: string; refresh_token: string }>('/auth/login', credentials);
  return {
    user: mapUserDTO(data.user),
    tokens: { accessToken: data.access_token, refreshToken: data.refresh_token },
  };
}
```

**UI Layer** (`features/auth/ui/`):

```tsx
// features/auth/ui/LoginForm.tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { Button, Input } from '@/shared/ui';
import { loginSchema, type LoginFormData } from '../model/schema';
import { login } from '../api/authApi';
import { useAuthStore } from '../model/store';

export function LoginForm() {
  const setAuth = useAuthStore((s) => s.setAuth);
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  });

  const onSubmit = async (data: LoginFormData) => {
    const { user, tokens } = await login(data);
    setAuth(user, tokens);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <Input {...register('email')} type="email" placeholder="Email" error={errors.email?.message} />
      <Input {...register('password')} type="password" placeholder="Password" error={errors.password?.message} />
      <Button type="submit" loading={isSubmitting}>Sign In</Button>
    </form>
  );
}
```

**Public API** (`features/auth/index.ts`):

```typescript
export { LoginForm } from './ui/LoginForm';
export { LogoutButton } from './ui/LogoutButton';
export { useAuthStore } from './model/store';
export { login, logout } from './api/authApi';
export type { LoginCredentials, AuthTokens } from './model/types';
```

---

## Widget Pattern

```tsx
// widgets/header/ui/Header.tsx
import { Link } from 'react-router-dom';
import { UserAvatar } from '@/entities/user';
import { LogoutButton, useAuthStore } from '@/features/auth';
import { SearchBox } from '@/features/search';

export function Header() {
  const { user, isAuthenticated } = useAuthStore();

  return (
    <header className="flex items-center justify-between px-6 py-4 border-b">
      <Link to="/"><Logo /></Link>
      <SearchBox />
      <nav className="flex items-center gap-4">
        {isAuthenticated ? (
          <><UserAvatar user={user!} size="sm" /><LogoutButton /></>
        ) : (
          <Link to="/login">Sign In</Link>
        )}
      </nav>
    </header>
  );
}

// widgets/header/index.ts
export { Header } from './ui/Header';
```

---

## Page Pattern

```typescript
// pages/product-detail/api/loader.ts
import { getProductById } from '@/entities/product';

export async function productDetailLoader({ params }: LoaderFunctionArgs) {
  return { product: await getProductById(params.id!) };
}
```

```tsx
// pages/product-detail/ui/ProductDetailPage.tsx
import { useLoaderData } from 'react-router-dom';
import { ProductCard, type Product } from '@/entities/product';
import { AddToCartButton } from '@/features/cart';
import { Header } from '@/widgets/header';

export function ProductDetailPage() {
  const { product } = useLoaderData() as { product: Product };
  return (
    <>
      <Header />
      <main className="max-w-4xl mx-auto py-8">
        <ProductCard product={product} />
        <AddToCartButton productId={product.id} />
      </main>
    </>
  );
}

// pages/product-detail/index.ts
export { ProductDetailPage } from './ui/ProductDetailPage';
export { productDetailLoader } from './api/loader';
```

---

## Shared API Client

```typescript
// shared/api/client.ts
import axios from 'axios';

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: { 'Content-Type': 'application/json' },
});

apiClient.interceptors.request.use((config) => {
  const storage = localStorage.getItem('auth-storage');
  if (storage) {
    const { state } = JSON.parse(storage);
    if (state?.tokens?.accessToken) {
      config.headers.Authorization = `Bearer ${state.tokens.accessToken}`;
    }
  }
  return config;
});
```
