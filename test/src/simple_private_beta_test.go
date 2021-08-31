package test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/dummy using Terratest
func TestExamplesComplete(t *testing.T) {
    t.Parallel()

    gcpRegion := "europe-west3"

    terraformOptions := &terraform.Options{
        // The path to where our Terraform code is defined
        TerraformDir: "../../examples/simple_private_beta",
        // The max line size of stdout and stderr
        OutputMaxLineSize: 128 * 1024,
        // Opt to upgrade modules and plugins as part of init step
        Upgrade: true,
        // Variables to pass through the -var-file option
        VarFiles: []string{"fixtures.europe-west3.tfvars"},
        // Environment variables to set when running Terraform
        EnvVars: map[string]string{
            "GOOGLE_REGION": gcpRegion,
        },
    }

    // Teardown: at the end of the test, destroy any resources that were created
    defer terraform.Destroy(t, terraformOptions)

    // This will setup the test and fail if there are any errors
    terraform.InitAndApply(t, terraformOptions)

    // Run terraform output to get the value of an output variable
    name := terraform.Output(t, terraformOptions, "dummy_name")
    // Verify we're getting back the outputs we expect
    assert.Equal(t, "go-euw3-bk-poc-dummy-gke01-epd", name)
}
