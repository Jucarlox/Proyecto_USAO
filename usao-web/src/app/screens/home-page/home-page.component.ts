import { Component, OnInit } from '@angular/core';
//import { ViviendaResponse } from 'src/app/interfaces/vivienda.interface';
//import { ViviendasService } from 'src/app/services/viviendas.service';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.css']
})
export class HomePageComponent implements OnInit {

  //top5Viviendas: ViviendaResponse[] = [];

  constructor(/*private viviendasService : ViviendasService*/) { }

  ngOnInit(): void {

      /*this.viviendasService.getTop6Viviendas().subscribe(viviendaResponse => {
        this.top5Viviendas = viviendaResponse;
      });*/
    }  

}
