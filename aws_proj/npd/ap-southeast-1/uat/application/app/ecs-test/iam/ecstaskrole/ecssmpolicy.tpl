{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:CreateGrant"
            ],
            "Resource": [
                "arn:aws:kms:ap-southeast-1:381491961008:key/c8d57278-8479-4454-abe9-62a35d867fa0",
                "arn:aws:kms:ap-southeast-1:381491961008:key/cdcb509a-da9e-46a4-b250-c8f5f657c493"
            ]
        }  
    ]
}
