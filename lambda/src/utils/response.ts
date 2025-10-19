import type { APIGatewayProxyResult } from "aws-lambda";

interface UploadResponse {
  message: string;
  bucket: string;
  key: string;
  size: number;
}

interface ErrorResponse {
  error: string;
}

export const createResponse = (statusCode: number, body: UploadResponse | ErrorResponse): APIGatewayProxyResult => {
  return {
    statusCode,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  };
};