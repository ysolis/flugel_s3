package test

import (
	"io"
	"time"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"

	"net/http"
	"net/http/httptest"
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

	output_alb := terraform.Output(t, terraformOptions, "alb-url")
	assert.Contains(t, output_alb, "fugel-alb-")
	assert.Contains(t, output_alb, "elb.amazonaws.com")

	handler := func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "ping")
	}

	time.Sleep( 30 * time.Second )

	req1 := httptest.NewRequest("GET", "http://" + output_alb + "/test1.txt", nil)
	w1 := httptest.NewRecorder()
	handler(w1, req1)
	result1 := w1.Result()
	assert.Equal(t, result1.StatusCode, 200)
	assert.Equal(t, result1.Status, "200 OK")

	req2 := httptest.NewRequest("GET", "http://" + output_alb + "/test2.txt", nil)
	w2 := httptest.NewRecorder()
	handler(w2, req2)
	result2 := w2.Result()
	assert.Equal(t, result2.StatusCode, 200)
	assert.Equal(t, result2.Status, "200 OK")
}
