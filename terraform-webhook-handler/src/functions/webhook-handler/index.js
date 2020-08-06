const cryptoRandomString = require('crypto-random-string')
const SQS = require('aws-sdk/clients/sqs')

const AWS_REGION = 'us-east-1'
const WEBHOOK_EVENT_QUEUE = 'webhook-event-queue.fifo'

const sqs = new SQS({ apiVersion: '2012-11-05', region: AWS_REGION })

async function getQueueUrl(queueName) {
  const { QueueUrl } = await sqs.getQueueUrl({ QueueName: queueName }).promise()
  return QueueUrl
}

async function sendMessage(queueUrl, message) {
  return sqs.sendMessage({
    QueueUrl: queueUrl,
    // must be present at all cost in FIFO queues
    MessageGroupId: 'finicity',
    MessageBody: message
  }).promise()
}

exports.handler = async function (event) {
  console.log('event ==>', event)

  const statusCode = 200
  const headers = {
    'Content-Type': 'application/json'
  }
  const body = JSON.stringify({
    message: 'Random crypto retrieved',
    crypto: cryptoRandomString({ length: event.body.length })
  })

  console.log('event queue =>', WEBHOOK_EVENT_QUEUE)

  const queueUrl = await getQueueUrl(WEBHOOK_EVENT_QUEUE)

  console.log('queueUrl =>', queueUrl)

  const sentMessage = await sendMessage(queueUrl, body)

  console.log('sentmessage => ', sentMessage)

  return {
    statusCode,
    headers,
    body
  }
}
