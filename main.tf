terraform {

  cloud {
    organization = "{your-organization-name}"
    workspaces {
      name = "{your-workspace-name}"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "{your-bucket-name}"

}

resource "aws_s3_bucket_ownership_controls" "website_bucket_ownership_controls" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.website_bucket_public_access_block
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_bucket_website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "./content/index.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "style.css"
  source       = "./content/style.css"
  content_type = "text/css"
  acl          = "public-read"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "./content/error.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_cloudfront_distribution" "website_cdn" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name # DNS name to fetch content from
    origin_id   = "S3-${aws_s3_bucket.website_bucket.id}"                  # unique identifier for origin
  }

  enabled = true # is distribution enabled

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"] # Methods that CloudFront processes and forwards to the origin, GET and HEAD are typical for static sites
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}" # origin to route requests to

    forwarded_values {
      query_string = false # do not forward query strings to origin

      cookies {
        forward = "none" # do not forward cookies to origin
      }
    }

    viewer_protocol_policy = "redirect-to-https" # redirect HTTP requests to HTTPS, this improves security

    # ttl determines how long CloudFront caches objects, it's in seconds
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100" # Geo locations to deliver content, this is the cheapest option, only US, Canada and Europe

  # restriction configures who can or can't access the content
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Configures the SSL/TLS certificate to use, default is the one provided by AWS
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
