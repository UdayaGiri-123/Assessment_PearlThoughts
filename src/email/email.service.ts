import { Injectable } from '@nestjs/common';
import { SQS } from 'aws-sdk';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
    private sqs:SQS;
    private queueUrl:string;
    private transporter;

    constructor(){
        this.sqs = new SQS({
            region:process.env.AWS_REGION,
        });

        this.queueUrl = process.env.SQS_QUEUE_URL;
        this.transporter=nodemailer.createTransport({
            service:'Gmail',
            auth:{
                user:process.env.EMAIL_USER,
                pass:process.env.EMAIL_PASS,
            },
        });   
}

onModueInit(){
    this.listenForMessages();
}
async listenForMessages() {
    const params={
        QueueUrl: this.queueUrl,
        WaitTimeSeconds : 20,
    };
    while(true){
        const data = await this.sqs.receiveMessage(params).promise();

        if(data.Messages && data.Messages.length >0)
            {
                for(const msg of data.Messages){
                    await this.sendEmail(msg.Body);
                    await this.sqs.deleteMessage({
                        QueueUrl: this.queueUrl,
                        ReceiptHandle:msg.ReceiptHandle,
                    }).promise();
                }
            }
    }
}

async sendEmail(message: string)
{
    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: process.env.EMAIL_TO,
        subject:'Notification',
        text:message,
    };
    return this.transporter.sendMail(mailOptions);
}
}