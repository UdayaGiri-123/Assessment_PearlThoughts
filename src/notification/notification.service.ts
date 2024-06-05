import { Injectable } from '@nestjs/common';
import { SQS } from 'aws-sdk';

@Injectable()
export class NotificationService {
    private sqs:SQS;
    private queueUrl:string;
    constructor(){
        this.sqs = new SQS({region:'us-east-1'});
        this.queueUrl = process.env.SQS_QUEUE_URL;
    }
    async sendNotification(message : string)
    {
        const params = {
            QueueUrl: this.queueUrl,
            MessageBody:message,
        };
        return this.sqs.sendMessage(params).promise();
    }
}
