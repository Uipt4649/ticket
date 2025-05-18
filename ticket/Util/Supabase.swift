//
//  Supabase.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://hnkkioqbzbwgcxmowrzr.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhua2tpb3FiemJ3Z2N4bW93cnpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2NzY0NzQsImV4cCI6MjA1NTI1MjQ3NH0.80xh5R-66lNGN1-CSEwaS37FBAToc1eMsglq7AaXnh4"
)
