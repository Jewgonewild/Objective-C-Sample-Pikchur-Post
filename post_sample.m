/*
 turning the image into a NSData object
 getting the image back out of the UIImageView
 setting the quality to 100
 */
NSData *imageData = UIImageJPEGRepresentation(image.image, 100);

/*setting up the URL to post to ( this could be xml or json, by default xml is returned. josn ex: http://api.pikchur.com/post/json*/
NSString *urlString = @"http://api.pikchur.com/post/";

// setting up the request object now
NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
[request setURL:[NSURL URLWithString:urlString]];
[request setHTTPMethod:@"POST"];

/*
 add some header info now
 we always need a boundary when we post a file
 also we need to set the content type
 
 You might want to generate a random boundary.. this is just the same 
 as my output from wireshark on a valid html post
 */
NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
[request addValue:contentType forHTTPHeaderField: @"Content-Type"];

/*
 now lets create the body of the post
 */
NSMutableData *body = [NSMutableData data];
//dataAPIimage 
[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"dataAPIimage\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[NSData dataWithData:imageData]];
[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

//data[api][auth_key]
[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"data[api][auth_key]\"; \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"yourauthkey"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];


//data[api][status]
[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"data[api][status]\"; \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"Test Iphone upload!"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];


//data[api][key]
[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"data[api][key]\"; \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithString:@"MZjGPcMDdr0Bew9C0GRR5A"] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];


// setting the body of the post to the reqeust
[request setHTTPBody:body];

// now lets make the connection to the web
NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

NSLog(returnString);