resource "aws_iam_user" "codecommit-user" {
  name = "test-user"
}

data "aws_iam_policy_document" "codecommit-policy" {
  statement{
    effect="Allow"
    actions  =[ "codecommit:*"]
    resources =["*"]
  }
}

resource "aws_iam_policy" "policy" {
    
  name   = "test"
  policy = data.aws_iam_policy_document.codecommit-policy.json
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = aws_iam_user.codecommit-user.name
  policy_arn = aws_iam_policy.policy.arn
}