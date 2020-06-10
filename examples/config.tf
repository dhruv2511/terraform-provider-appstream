provider "appstream" {
    access_key              = "AKIA3HSEGW5W5GXGGZN2"
    secret_key              = "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"
    region                  = "us-east-1"
}


//updates not supported by service, only state (RUNNING, STOPPED) operations
resource "appstream_image_builder" "test-image-builder" {
    name                    = "test-image-builder"
    appstream_agent_version = "LATEST"
    description             = "test image builder"
    display_name            = "test-image-builder"
    enable_default_internet_access = true
    image_arn               = "Amazon-AppStream2-Sample-Image-02-04-2019"
    instance_type            = "stream.standard.large"
    vpc_config {
        security_group_ids  = "sg-b5af81d3"
        subnet_ids          = "subnet-7a5f4b51"
    }
    state                   = "RUNNING"
}


resource "appstream_stack" "test-stack" {
    name                    = "test-stack"
    description             = "appstream test stack"
    display_name            = "test-stack"
    feedback_url            = "http://example1.com"
    redirect_url            = "http://example1.com"
    storage_connectors  {
        connector_type      = "HOMEFOLDERS"
    }
    user_settings {
        file_download = "DISABLED"
        file_upload = "DISABLED"
        copy_from_local = "DISABLED"
        copy_to_local = "DISABLED"
        allow_local_device_printing = "DISABLED"

    }
    tags = {
        Env     = "lab"
        Role    = "appstream-stack"
    }
}

resource "appstream_fleet" "test-fleet" {
    name                    = "test-fleet"
    stack_name              = appstream_stack.test-stack.name
    compute_capacity {
        desired_instances   = 1
    }
    description             = "test fleet"
    disconnect_timeout      = 300
    display_name            = "test-fleet"
    enable_default_internet_access = true
    fleet_type              = "ON_DEMAND"
    image_arn               = appstream_image_builder.test-image-builder.image_arn
    instance_type           = "stream.standard.large"
    max_user_duration       = 600
    vpc_config {
        security_group_ids  = "sg-d3d53580"
        subnet_ids          = "subnet-af3807c8"
    }
    tags = {
        Env     = "lab"
        Role    = "appstream-fleet"
    }
    state                   = "RUNNING"
}
