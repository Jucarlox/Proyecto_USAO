import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { LoginDto } from '../dto/login';
import { RegisterDto } from '../dto/register';
import { LoginResponse } from '../interfaces/login.interface';
import { RegisterResponse } from '../interfaces/register.interface';

const URL= `${environment.apiBaseUrl}`;


const DEFAULT_HEADERS = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  @Injectable({
    providedIn: 'root'
  })


  export class AuthService {
  constructor(private http : HttpClient) { }

  postLogin(dto: LoginDto): Observable<LoginResponse> {
    let requestUrl = `${URL}/auth/login`;
    return this.http.post<LoginResponse>(requestUrl, dto, DEFAULT_HEADERS);
  }

  postRegister(dto: RegisterDto): Observable<RegisterResponse> {
    let requestUrl = `${URL}/auth/register`;
    return this.http.post<RegisterResponse>(requestUrl, dto, DEFAULT_HEADERS);
  }

  }