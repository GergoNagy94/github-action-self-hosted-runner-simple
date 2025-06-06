## 1. Choosing EC2 Instance Type

- **Workload:**
  - Light CI/CD: `t3.micro` (2 vCPU, 1 GB RAM)
  - Heavy tasks (e.g., builds): `t3.medium`, `c5.large`
- **Cost Efficiency:**
  - Use `t3` burstable or ARM-based `t4g` for better price/performance
  - Spot instances can save up to 90%

## 2. AWS Resource Access by Workflow
- **IAM Role:**
  - EC2 instance uses `gergo-github-runner-role` with `s3:ListAllMyBuckets` permission
- **Workflow Access:**
  - Uses `aws-actions/configure-aws-credentials@v4` to get temporary credentials from EC2 metadata
- **Security:**
  - Follow least privilege principle

## 3. Handling Sensitive Data (e.g., GitHub Token)
- **Access:**
  - Token used in `user_data.sh` during EC2 bootstrap
- **Best Practices:**
  - Avoid hardcoding secrets

## 4. Self-Hosted Runner: Pros & Cons
### Pros:
- Lower cost for high usage (especially Spot instances)
- Fully customizable environment
- Private AWS resource access
- Full infrastructure control

### Cons:
- Requires setup and maintenance
- Higher complexity (VPC, IAM, NAT, etc.)

## 5. Internet Access for Runner
- NAT Gateway in public subnet enables internet access for private EC2
- Security group allows all outbound traffic
- **Alternative:** Use VPC endpoints for AWS APIs to reduce NAT Gateway costs

## 6. Cost Comparison (eu-central-1, 720 hrs/month)

Option                  Monthly Cost

EC2 (t3.micro Spot)     $2.16            
NAT Gateway             $32.85           
EBS (8 GB gp3)          $0.64            
**Total (Spot)**        **$35.65**      

GitHub Hosted (400 min)     $3.20
GitHub Hosted (2400 min)    $19.20

### Recommendation:
- **Low workload:** Use GitHub-hosted runners
- **Heavy workload or private access needs:** Use self-hosted runner with Spot EC2

## Additional Notes

- **Reusable setup:** Extend to multiple repos or org-level runners
- **SSM access:** Configured and working
- **Security:** Use Secrets Manager, rotate tokens regularly