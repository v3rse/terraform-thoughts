const SQS = require('aws-sdk/clients/sqs')
const { handler } = require('./index')

jest.mock('aws-sdk/clients/sqs')

let sqsGetQueueUrlPromise
let sqsSendMessage

describe.skip('webhook handler unit test', () => {
  let event

  beforeEach(() => {
    event = {
      body: {
        length: 10
      }
    }

    sqsGetQueueUrlPromise = jest.fn().mockReturnValue({
      promise: jest.fn().mockResolvedValue({
        QueueUrl: 'http://aws.queueurl.com'
      })
    })

    sqsSendMessage = jest.fn()

    SQS.mockImplementation(() => ({
      getQueueUrl: sqsGetQueueUrlPromise,
      sendMessage: sqsSendMessage
    }))

    console.log();
  })

  it('should return statusCode "200"', async () => {
    const { statusCode } = await handler(event)
    expect(statusCode).toEqual(200)
  })

  it('should return json content-type in header', async () => {
    const { headers: { 'Content-Type': contentType } } = await handler(event)
    expect(contentType).toEqual('application/json')
  })

  it(`should return crypto string same length as input string`, async () => {
    const { body } = await handler(event)
    const { crypto } = JSON.parse(body)
    expect(crypto.length).toBe(event.body.length)
  })

  it('should call getQueueUrl with queueName', async () => {
    await handler(event)
    expect(sqsGetQueueUrlPromise).toHaveBeenCalledWith({ QueueName: 'webhook-event-queue.fifo' })
  })

  it('should call sendMessage with message', async () => {
    const { body } = await handler(event)
    expect(sqsSendMessage).toHaveBeenCalled({
      QueueUrl: 'http://aws.queueurl.com',
      MessageBody: body
    })
  })
})