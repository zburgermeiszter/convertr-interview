import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import type { APIGatewayProxyEvent, APIGatewayProxyResult, Context } from 'aws-lambda';
import { HTTPError } from './utils/errors';
import { generateFileNameFromEvent, getBodyBufferFromEvent, validateEvent } from './utils/event';
import { createResponse } from './utils/response';

const s3Client = new S3Client({ region: process.env.AWS_REGION || 'eu-west-2' });

export const handler = async (event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> => {
  console.log('Event:', JSON.stringify(event, null, 3));

  try {
    const bucketName = process.env.BUCKET_NAME;
    if (!bucketName) {
      throw new Error('BUCKET_NAME environment variable not set');
    }

    validateEvent(event);

    const fileName = await generateFileNameFromEvent(event);

    console.log('Processing upload');

    const imageBuffer = await getBodyBufferFromEvent(event);
    const s3Key = `uploads/${fileName}`;

    const putCommand = new PutObjectCommand({
      Bucket: bucketName,
      Key: s3Key,
      Body: imageBuffer,
    });

    await s3Client.send(putCommand);

    console.log(`Successfully uploaded ${s3Key} to ${bucketName}`);

    return createResponse(200, {
      message: 'Picture uploaded successfully',
      bucket: bucketName,
      key: s3Key,
      size: imageBuffer.length,
    });
  } catch (error) {
    console.error('Error:', error);

    if (error instanceof HTTPError) {
      createResponse(error.code, { error: error.message });
    }

    return createResponse(500, {
      error: `Internal server error: ${error instanceof Error ? error.message : 'Unknown error'}`,
    });
  }
};
