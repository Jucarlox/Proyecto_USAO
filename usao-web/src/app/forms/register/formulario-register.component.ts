import { Component, OnInit } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";

import { ActivatedRoute, Router } from "@angular/router";
import { DialogErrorComponent } from "src/app/dialog/error/dialog-error.component";
import { RegisterDto } from "src/app/dto/register";

import { AuthService } from "src/app/services/auth.service";

@Component({
  selector: 'app-formulario-register',
  templateUrl: './formulario-register.component.html',
  styleUrls: ['./formulario-register.component.css']
})
export class FormularioRegisterComponent implements OnInit {

  RegisterDto = new RegisterDto();
  
  fileToUpload: File | null = null;


  constructor(private route: ActivatedRoute, private authService: AuthService, private router: Router, private dialog: MatDialog) { }


  ngOnInit(): void { }

 

  onSubmit() {

    

    
    console.log(this.RegisterDto.fechaNacimiento)
    console.log(this.RegisterDto.nick)
    console.log(this.RegisterDto.email)
    console.log(this.RegisterDto.password)
    console.log(this.RegisterDto.password2)
    console.log(this.RegisterDto.localizacion)
    this.authService.postRegister(this.RegisterDto).subscribe(() => {
     
        
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
