# coding: utf-8

from __future__ import absolute_import

from swagger_server.models.data_type import DataType
from . import BaseTestCase
from six import BytesIO
from flask import json


class TestSummaryController(BaseTestCase):
    """ SummaryController integration test stubs """

    def test_linked_types(self):
        """
        Test case for linked_types

        
        """
        response = self.client.open('/api/types',
                                    method='GET')
        self.assert200(response, "Response body is : " + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
