class Search():
    def _search(self, table_type=str, col_type=str, search_data=str):
        return {
            'down_chrome' : "select * from down_chrome where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'driver_win7' : "select * from driver_win7 where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'fscan' : "select * from fscan where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'hist_chrome' : "select * from hist_chrome where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'hist_ie' : "select * from hist_ie where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'logonoff' : "select * from logonoff where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'oafile' : "select * from oafile where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'oamtp' : "select * from oamtp where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'part_win10' : "select * from part_win10 where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'qscan' : "select * from qscan where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'reg' : "select * from reg where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'zscan' : "select * from zscan where {0} like '%{1}%'".format(
                 col_type, search_data
            ),
            'rfile': "select * from rfile where {0} like '%{1}%'".format(
                col_type, search_data
            ),
            'mft': "select * from mft where {0} like '%{1}%'".format(
                col_type, search_data
            ),
            'usnjrnl': "select * from usnjrnl where {0} like '%{1}%'".format(
                col_type, search_data
            ),
            'archive': "select * from archive where {0} like '%{1}%'".format(
                col_type, search_data
            )
        }.get(table_type)
