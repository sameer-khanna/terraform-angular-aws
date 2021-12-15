import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Constants } from '../constants/constants';

@Injectable({
  providedIn: 'root'
})
export class HomeService {
  httpOptions = {
    headers: new HttpHeaders({
      'responseType': 'text'
    })
  };

  constructor(private http:HttpClient, private constants: Constants) { }

  public helloWorld() {
    return this.http.get<string>(this.constants.HELLO_WORLD, this.httpOptions);
  }
}
