import { Component, OnInit } from '@angular/core';
import { HomeService } from './home.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  restAPIReturn = "";
  constructor(private homeService: HomeService) { }

  ngOnInit(): void {
  }

  callRestAPI() {
    this.homeService.helloWorld().subscribe(data => {
      this.restAPIReturn = data;
    })
  }

}
