import axios from 'axios';
import { deserialise } from 'kitsu-core';
import _ from 'lodash';
import qs from 'qs';
import React from 'react';

function withApi(WrappedComponent) {
  class WithApi extends React.Component {
    constructor(props) {
      super(props);

      this.initApi();
    }

    getErrorsFor = (field, errors) => {
      const fieldErrors = errors[field];

      if (!fieldErrors) return '';

      return fieldErrors.join(', ');
    };

    initApi = () => {
      const csrfToken = document
        .getElementsByName('csrf-token')[0]
        .getAttribute('content');

      this.api = axios.create({
        headers: {
          Accept: 'application/json',
          'X-CSRF-Token': csrfToken,
          'X-Key-Inflection': 'camel'
        },
        paramsSerializer: params => qs.stringify(params),
        timeout: 5000
      });
    };

    parseApiResponse = async (response, includeMeta) => {
      const result = await deserialise(response.data);

      return includeMeta ? result : result.data;
    };

    parseApiError = async errorResponse => {
      const result = await deserialise(errorResponse.response.data);

      const parsedErrors = {};

      result.errors.forEach(error => {
        if (
          _.has(error, 'source.pointer') &&
          error.source.pointer.startsWith('/data/attributes/')
        ) {
          const attr = _.last(error.source.pointer.split('/'));
          const msg = error.detail;

          if (_.has(parsedErrors, attr)) {
            parsedErrors[attr].push(msg);
          } else {
            parsedErrors[attr] = [msg];
          }
        }
      });

      return parsedErrors;
    };

    resourceListParams = state => {
      const defaultPageSize = 25;
      const params = {};

      if (!state) return params;

      if (state.filters) {
        params.filter = {};

        state.filters.forEach(
          filter => (params.filter[filter.key] = filter.value)
        );
      }

      if (state.pageNumber) {
        params.page = {
          number: state.pageNumber,
          size: state.pageSize || defaultPageSize
        };
      }

      if (state.searchQuery) {
        params.search = state.searchQuery;
      }

      if (state.sortBy) {
        const match = /(.*)_((?:a|de)sc)/.exec(state.sortBy);

        if (match) {
          const field = match[1];
          const descSignifier = match[2] === 'desc' ? '-' : '';

          params.sort = `${descSignifier}${field}`;
        }
      }

      return params;
    };

    render() {
      return (
        <WrappedComponent
          api={this.api}
          getErrorsFor={this.getErrorsFor}
          parseApiResponse={this.parseApiResponse}
          parseApiError={this.parseApiError}
          resourceListParams={this.resourceListParams}
          {...this.props}
        />
      );
    }
  }

  return WithApi;
}

export default withApi;
