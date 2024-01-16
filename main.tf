terraform {

  cloud {
    organization = "tiger_projects"
    workspaces {
      name = "serverless-website-hosting"
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
  bucket = "tiger-kun-website-bucket"

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

