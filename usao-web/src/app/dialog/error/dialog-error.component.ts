import { Component, Inject, Input, OnInit } from '@angular/core';


@Component({
  selector: 'app-dialog-error',
  templateUrl: './dialog-error.component.html',
  styleUrls: ['./dialog-error.component.css']
})
export class DialogErrorComponent implements OnInit {

 
  
  @Input() message!: String;
  

  constructor() { }

  ngOnInit(): void {
    this.message;
    
  }
}