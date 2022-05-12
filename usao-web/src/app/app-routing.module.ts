import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FormularioLoginComponent } from './forms/login/formulario-login.component';
import { HomePageComponent } from './screens/home-page/home-page.component';

const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  { path: 'usuarios', component: HomePageComponent },
  { path: 'login', component: FormularioLoginComponent },
  //{ path: 'register', component: RegisterComponent },
  { path: '', pathMatch: 'full', redirectTo: '/login'}
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
