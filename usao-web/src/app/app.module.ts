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


@NgModule({
  declarations: [
    AppComponent,
    SideMenuComponent,
    HomePageComponent,
    FormularioLoginComponent,
    DialogErrorComponent
    //RegisterComponent

  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MaterialImportsModule,
    HttpClientModule,
    FormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
