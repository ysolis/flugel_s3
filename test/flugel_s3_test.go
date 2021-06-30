package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformFlugelS3(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	output_bucket := terraform.Output(t, terraformOptions, "flugel_s3_bucket_name")
	assert.Contains(t, output_bucket, "flugel-bucket-")

	output_objects := terraform.Output(t, terraformOptions, "flugel_s3_bucket_objects")
	assert.Contains(t, output_objects, "test1.txt")
	assert.Contains(t, output_objects, "test2.txt")
}
