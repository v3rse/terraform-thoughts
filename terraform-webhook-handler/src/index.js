const cryptoRandomString = require('crypto-random-string')

exports.handler = async function (event) {
  console.log(event)
  const statusCode = 200
  const headers = {
    'Content-Type': 'application/json'
  }
  const body = JSON.stringify({
    message: 'Random crypto retrieved',
    crypto: cryptoRandomString({ length: event.body.length })
  })

  return {
    statusCode,
    headers,
    body
  }
}
