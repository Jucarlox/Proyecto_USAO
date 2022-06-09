import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SideMenuComponent } from './shared/side-menu/side-menu.component';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MaterialImportsModule } from './modules/material-imports.module';
import { HomePageComponent } from './screens/home-page/home-page.component';

//import { RegisterComponent } from './forms/register/register.component';
import { FormularioLoginComponent } from './forms/login/formulario-login.component';
import { DialogErrorComponent } from './dialog/error/dialog-error.component';
import { FormularioRegisterComponent } from './forms/register/formulario-register.component';
import {MatDatepickerModule} from '@angular/material/datepicker';
import { MatButtonModule } from '@angular/material/button';
import { MatNativeDateModule } from '@angular/material/core';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ListaUsuariosComponent } from './components/lista-usuarios/lista-usuarios.component';
import { ListaProductosComponent } from './components/lista-productos/lista-productos.component';





@NgModule({
  declarations: [
    AppComponent,
    SideMenuComponent,
    HomePageComponent,
    FormularioLoginComponent,
    FormularioRegisterComponent,
    DialogErrorComponent,
    ListaUsuariosComponent,
    ListaProductosComponent
    

  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MaterialImportsModule,
    HttpClientModule,
    FormsModule,
    MatDatepickerModule,
    MatButtonModule,
    MatFormFieldModule,
    MatNativeDateModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
