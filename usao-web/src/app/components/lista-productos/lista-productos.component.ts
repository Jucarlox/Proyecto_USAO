import { Component, OnInit } from '@angular/core';
import {MatTableDataSource} from '@angular/material/table';
import { ProductoResponse } from 'src/app/interfaces/producto.interface';
import { ProductoService } from 'src/app/services/producto.service';


@Component({
  selector: 'app-lista-productos',
  templateUrl: './lista-productos.component.html',
  styleUrls: ['./lista-productos.component.css']
})
export class ListaProductosComponent implements OnInit {

  productoList!: ProductoResponse[] ;
  
  displayedColumns: string[] = ['id', 'nombre', 'categoria', 'precio', 'fileScale','actions'];
  dataSource : any;
  constructor(private productoService : ProductoService) { }

  ngOnInit(): void {
    this.productoService.getListProductos().subscribe(productosResponse => {
      this.productoList = productosResponse.slice(0,20);
      this.dataSource = new MatTableDataSource(this.productoList);
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  deleteProdcuto(id:String){
    this.productoService.deleteProducto(id).subscribe(vacio=>{
      location.reload();
    });
  }

  

  
}