variable "webhook_event_queue_name" {
  type = string
}

resource "aws_sqs_queue" "webhook_event_queue" {
  name                        = var.webhook_event_queue_name
  fifo_queue                  = true
  content_based_deduplication = true
}
