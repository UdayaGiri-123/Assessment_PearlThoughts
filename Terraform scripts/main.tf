#SQS service
resource "aws_sqs_queue" "notification_queue" {
  name =  "notification_service-queue"
  delay_seconds = 30
  max_message_size = 2048
  message_retention_seconds = 60
  receive_wait_time_seconds = 20
  
}
