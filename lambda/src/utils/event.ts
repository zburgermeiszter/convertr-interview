import type { APIGatewayProxyEvent } from 'aws-lambda';
import { HTTPError } from './errors';
import { fileTypeFromBuffer } from 'file-type';

type APIGatewayProxyEventWithBody = APIGatewayProxyEvent & {
  body: string;
};

export const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];

const hasBody = (event: APIGatewayProxyEvent): event is APIGatewayProxyEventWithBody =>
  event.body !== null && event.body !== '';

export const getBodyBufferFromEvent = (event: APIGatewayProxyEvent) => {
  const { body } = event;

  if (!body) {
    throw new HTTPError(400, 'Missing body');
  }

  return Buffer.from(body, 'base64');
};

export const generateFileNameFromEvent = async (event: APIGatewayProxyEvent) => {
  const buffer = getBodyBufferFromEvent(event);
  const fileTypeResult = await fileTypeFromBuffer(buffer);

  if (!fileTypeResult) {
    throw new HTTPError(400, 'Unable to detect file type.');
  }

  const { ext, mime } = fileTypeResult;

  if (!allowedMimeTypes.includes(mime)) {
    throw new HTTPError(400, 'Unsupported file type (magic bytes)');
  }

  return `${event.requestContext.requestId}.${ext}`;
};

export const validateEvent = (event: APIGatewayProxyEvent): APIGatewayProxyEventWithBody => {
  const { headers, isBase64Encoded } = event;

  if (!allowedMimeTypes.includes(headers?.['content-type'] || '')) {
    throw new HTTPError(400, 'Unsupported Content-Type');
  }

  if (!isBase64Encoded) {
    throw new HTTPError(400, 'Base64 encoded body expected from API Gateway');
  }

  if (!hasBody(event)) {
    throw new HTTPError(400, 'Missing body');
  }

  return event;
};
