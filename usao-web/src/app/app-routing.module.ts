import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaProductosComponent } from './components/lista-productos/lista-productos.component';
import { ListaUsuariosComponent } from './components/lista-usuarios/lista-usuarios.component';
import { FormularioLoginComponent } from './forms/login/formulario-login.component';
import { FormularioRegisterComponent } from './forms/register/formulario-register.component';
import { HomePageComponent } from './screens/home-page/home-page.component';

const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  
  { path: 'login', component: FormularioLoginComponent },
  { path: 'register', component: FormularioRegisterComponent },
  { path: 'usuarios', component:ListaUsuariosComponent},
  { path: 'productos', component:ListaProductosComponent},
  { path: '', pathMatch: 'full', component: FormularioLoginComponent}
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
