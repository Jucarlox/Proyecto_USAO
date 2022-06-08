import { Component, OnInit } from '@angular/core';
import { PropietarioResponse } from 'src/app/interfaces/propietario.interface';
import { PropietarioService } from 'src/app/services/propietario.service';

@Component({
  selector: 'app-lista-usuarios',
  templateUrl: './lista-usuarios.component.html',
  styleUrls: ['./lista-usuarios.component.css']
})
export class ListaUsuariosComponent implements OnInit {

  propietarioList!: PropietarioResponse[] ;


  constructor(private propietarioService : PropietarioService) { }

  ngOnInit(): void {
    this.propietarioService.getListPropietario().subscribe(propietarioResponse => {
      this.propietarioList = propietarioResponse;
    });
  }
}