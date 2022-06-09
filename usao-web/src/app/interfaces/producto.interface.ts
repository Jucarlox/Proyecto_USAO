export interface Propietario {
    id: string;
    nick: string;
    email: string;
    localizacion: string;
    fechaNacimiento: string;
    avatar: string;
    role: string;
}

export interface ProductoResponse {
    id: number;
    nombre: string;
    descripcion: string;
    categoria: string;
    precio: number;
    propietario: Propietario;
    fileScale: string;
    idUsersLike: any[];
}