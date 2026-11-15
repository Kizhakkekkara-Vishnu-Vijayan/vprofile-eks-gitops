# IAM policy reference (as submitted)

`provided-aws-load-balancer-controller-policy.json` is a transcription of the JSON included in the Phase 4 evidence PDF. It is an **evidence snapshot**, not a guarantee that the policy is the latest supported policy. For a fresh installation, obtain the policy from the AWS Load Balancer Controller release documentation, and inspect the permissions before applying it.

The IAM screenshot in `../screenshots/aws-lbc-iam-role-permissions.png` independently confirms that the cluster controller IAM role had a customer-managed policy named `AWSLoadBalancerControllerIAMPolicy`. The JSON submission does not, by itself, prove that every line was attached to the AWS role.
