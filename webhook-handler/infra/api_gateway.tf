resource "aws_api_gateway_rest_api" "webhook_gateway" {
  name        = "WebhookGateway"
  description = "A webhook gateway"
}

output "base_url" {
  value = aws_api_gateway_deployment.gateway_deployment.invoke_url
}
