import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';


@Component({
  selector: 'app-side-menu',
  templateUrl: './side-menu.component.html',
  styleUrls: ['./side-menu.component.css']
})
export class SideMenuComponent implements OnInit {
  
  currentPage = 'home';

  constructor(private router: Router) { }

  ngOnInit(): void {
    console.log(this.router.url);
  }

  isLogin(){
    return this.router.url == '/login';
  }

  isNotLogin(){
    return this.router.url !== '/login';
  }


  logOut(){
    localStorage.clear();
    this.router.navigate(['/login']);
  }
}
