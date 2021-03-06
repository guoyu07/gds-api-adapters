require 'gds_api/asset_manager'
require 'gds_api/content_store'
require 'gds_api/imminence'
require 'gds_api/licence_application'
require 'gds_api/need_api'
require 'gds_api/worldwide'
require 'gds_api/email_alert_api'

module GdsApi
  module Helpers
    def asset_manager_api(options = {})
      @asset_manager_api ||= GdsApi::AssetManager.new(Plek.current.find('asset-manager'), options)
    end

    def content_store(options = {})
      @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"), options)
    end

    def imminence_api(options = {})
      @imminence_api ||= GdsApi::Imminence.new(Plek.current.find("imminence"), options)
    end

    def licence_application_api(options = {})
      @licence_application_api ||= GdsApi::LicenceApplication.new(Plek.current.find("licensify"), options)
    end

    def need_api(options = {})
      @need_api ||= GdsApi::NeedApi.new(Plek.current.find("needapi"), options)
    end

    def worldwide_api(options = {})
      @worldwide_api ||= GdsApi::Worldwide.new(Plek.current.find("whitehall-admin"), options)
    end

    def email_alert_api(options = {})
      @email_alert_api ||= EmailAlertApi.new(Plek.current.find("email-alert-api"), options)
    end

    def self.included(klass)
      if klass.respond_to?(:helper_method)
        klass.helper_method :imminence_api, :licence_application_api
      end
    end
  end
end
