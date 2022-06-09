import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ProductoResponse } from '../interfaces/producto.interface';
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


  export class ProductoService {
  constructor(private http : HttpClient) { }

  getListProductos():Observable<ProductoResponse[]>{
    let url= `${URL}/producto`
    return this.http.get<ProductoResponse[]>(url, DEFAULT_HEADERS);
  }


  deleteProducto(id: String){
    let url= `${URL}/producto/${id}`
    return this.http.delete<UserResponse[]>(url, DEFAULT_HEADERS);
  }





  }