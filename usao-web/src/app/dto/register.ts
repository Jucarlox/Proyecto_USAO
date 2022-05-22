export class RegisterDto{
    nick: string;
    email: string;
    fechaNacimiento: string;
    avatar: string;
    password: string;
    password2: string;
    categoria: boolean;
    localizacion: string;

    constructor(){
        this.nick= '';
    this.email= '';
    this.fechaNacimiento= '';
    this.avatar= '';
    this.password= '';
    this.password2= '';
    this.categoria= true;
    this.localizacion= '';
    }

}