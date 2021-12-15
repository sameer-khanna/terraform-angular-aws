import { Injectable } from "@angular/core";

@Injectable() 
export class Constants {
public readonly API_ENDPOINT: string = 'http://www.sameerkhanna.net/api/'; 
public readonly HELLO_WORLD: string = this.API_ENDPOINT + 'helloworld'; 
} 