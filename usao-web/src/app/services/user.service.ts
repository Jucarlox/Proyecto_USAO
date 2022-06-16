import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { UserResponse } from '../interfaces/user.interface';

const URL= `${environment.apiBaseUrl}`;


const DEFAULT_HEADERS = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`,
    }),
  };

  @Injectable({
    providedIn: 'root'
  })


  export class UserService {
  constructor(private http : HttpClient) { }

  getListUser():Observable<UserResponse[]>{
    let url= `${URL}/listUsers`
    return this.http.get<UserResponse[]>(url, DEFAULT_HEADERS);
  }


  deleteUser(id: String){
    let url= `${URL}/profile/${id}`
    return this.http.delete<UserResponse[]>(url, DEFAULT_HEADERS);
  }





  }