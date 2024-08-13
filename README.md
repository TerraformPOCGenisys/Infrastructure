Grafana loki datasource url :

http://loki-loki-distributed-gateway.monitoring.svc.cluster.local

Grafana Mimir datasource url :

http://mimir-nginx.monitoring.svc:80/prometheus

**Steps for creating a terraform user an Inline Policy in the AWS Management Console**

1. **Log in to the AWS Management Console:**
    - Access the IAM console at <https://console.aws.amazon.com/iam/>
2. **Navigate to the Desired Entity:**
    - Choose either **Users**, **Groups**, or **Roles** from the navigation pane.
    - Select the specific user, group, or role you want to attach the inline policy to.
3. **Access Permissions Tab:**
    - In the details pane, select the **Permissions** tab.
4. **Create Inline Policy:**
    - Click **Add permissions** and then select **Create inline policy**.
5. **Choose Policy Creation Method: JSON editor**
    - You have two options:
        - **Visual editor:** Use a graphical interface to build the policy.
        - **JSON editor:** Directly input the JSON policy document.
6. **Define Permissions:**
    - **Visual editor:**
        - Select services and actions to grant permissions.
        - Use resource filters to specify which resources the policy applies to.
    - **JSON editor:**
        - Paste or manually enter the JSON policy.

{  
    "Version": "2012-10-17",  
    "Statement": \[  
        {  
            "Sid": "Statement1",  
            "Effect": "Allow",  
            "Action": \[  
                "ecr:\*",  
                "rds:\*",  
                "eks:\*",  
                "s3:\*",  
                "dynamodb:\*",  
                "iam:\*",  
                "ec2:\*",  
                "cloudwatch:\*",  
                "logs:\*",  
                "kms:\*"  
            \],  
            "Resource": \[  
                "\*"  
            \]  
        }  
    \]  
}

1. **Review and Create:**
    - Review the policy details.
    - Give the policy a name and description (optional).
    - Click **Create policy**.