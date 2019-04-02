namespace :apartment do
    task :create_tenants => :environment do
        Apartment::tenant_names.each do |tenant|
            begin
                puts("Creating #{tenant} tenant")
                Apartment::Tenant.create(tenant)
            rescue Apartment::TenantExists => e
                puts e.message
            end
        end
    end
end
