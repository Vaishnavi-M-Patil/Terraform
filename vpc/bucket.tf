resource "aws_s3_bucket" "buckets3" {
    bucket = "bucketforb92025"
    tags = {
        name = "terraBucket"
        env = "development"
    }
}
