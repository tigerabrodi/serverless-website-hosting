# Serverless Website Hosting

A project where we host a static website on AWS using S3 and Cloudfront.

All written in Terraform.

# Cloudfront

AWS CloudFront is a web service that speeds up the distribution of your static and dynamic web content, such as .html, .css, .js, and image files, to your users. It's a Content Delivery Network (CDN) that securely delivers data, videos, applications, and APIs to customers globally with low latency and high transfer speeds.

It works by caching your content in multiple data centers, known as edge locations, around the world. When a user requests content that you're serving with CloudFront, the user is routed to the edge location that provides the lowest latency (time delay), ensuring that the content is delivered with the best possible performance.

## Key Features of CloudFront:

1. **Global Network of Edge Locations**: CloudFront has a wide network of data centers worldwide. This network ensures that content is available closer to the user, reducing latency.

2. **Integration with AWS Services**: CloudFront is designed to work seamlessly with other AWS services like Amazon S3, Elastic Load Balancing, and AWS Shield for DDoS protection.

3. **Secure Content Delivery**: CloudFront supports several security features, including HTTPS for secure data transfer and AWS WAF (Web Application Firewall) integration to protect against web exploits.

4. **Customizable**: You can customize various aspects of your CloudFront distribution, such as caching behavior, origin settings, and security features.

5. **Live and On-Demand Streaming**: CloudFront supports both live and on-demand video streaming.

6. **Cost-Effective**: You pay only for what you use with no minimum commitments or upfront fees. CloudFront's pricing is based on the amount of data transferred out to the internet and the number of HTTP/HTTPS requests made.
