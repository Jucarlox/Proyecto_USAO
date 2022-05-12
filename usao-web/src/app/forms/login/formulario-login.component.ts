import { Component, OnInit } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";

import { ActivatedRoute, Router } from "@angular/router";
import { DialogErrorComponent } from "src/app/dialog/error/dialog-error.component";
import { LoginDto } from "src/app/dto/login";
import { AuthService } from "src/app/services/auth.service";

@Component({
  selector: 'app-formulario-login',
  templateUrl: './formulario-login.component.html',
  styleUrls: ['./formulario-login.component.css']
})
export class FormularioLoginComponent implements OnInit {

  LoginDto = new LoginDto();
  constructor(private route: ActivatedRoute, private authService: AuthService, private router: Router, private dialog: MatDialog) { }


  ngOnInit(): void { }

  onSubmit() {


    this.authService.postLogin(this.LoginDto).subscribe((loginResult) => {
      localStorage.setItem('token', loginResult.token);
      this.router.navigate(['/home']);
    }, () => {
      this.dialog.open(DialogErrorComponent, {
        height: '550px',
        width: '400px',
        data: ("Correo o contraseña invalida")
      })
    });



  }


}



/**function ValidateEmail(mail) 
{
 if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(myForm.emailAddr.value))
  {
    return (true)
  }
    alert("You have entered an invalid email address!")
    return (false)
} */
