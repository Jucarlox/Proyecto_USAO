import { Component, OnInit } from '@angular/core';
import {MatTableDataSource} from '@angular/material/table';
import { Router } from '@angular/router';
import { UserResponse } from 'src/app/interfaces/user.interface';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-lista-usuarios',
  templateUrl: './lista-usuarios.component.html',
  styleUrls: ['./lista-usuarios.component.css']
})
export class ListaUsuariosComponent implements OnInit {

  userList!: UserResponse[] ;
  
  displayedColumns: string[] = ['avatar', 'fechaNacimiento', 'email', 'nick', 'localizacion','actions'];
  dataSource : any;
  constructor(private userService : UserService, private router: Router) { }

  ngOnInit(): void {
    this.userService.getListUser().subscribe(usersResponse => {
      this.userList = usersResponse.slice(0,20);
      this.dataSource = new MatTableDataSource(this.userList);
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  deleteUser(id:String){
    this.userService.deleteUser(id).subscribe(vacio=>{
      location.reload();
    });
  }

  
}