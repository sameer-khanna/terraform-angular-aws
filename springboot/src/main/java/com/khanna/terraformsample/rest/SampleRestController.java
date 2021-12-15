package com.khanna.terraformsample.rest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
//@CrossOrigin(origins = "*", allowedHeaders = "*", methods = {RequestMethod.GET, RequestMethod.OPTIONS, RequestMethod.HEAD}, exposedHeaders = "*")
public class SampleRestController {

	@GetMapping("/helloworld")
	public String helloWorld() {
		return "\"This String is returned from a REST API (built using Spring boot) that is deployed on the App tier.\"";
	}

}
