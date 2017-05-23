# Training
Use the Terraform configurations in each of the directories below to setup a training lab for a student for that course.

If you are setting up labs for multiple students, use the following pattern.

```
terraform env new someone
terraform apply -var-file .\secret.tfvars -var student=someone
```

Similarly, for tearing down the labs, use the following pattern

```
terraform env select someone
terraform destroy -var-file .\secret.tfvars -var student=someone
```
